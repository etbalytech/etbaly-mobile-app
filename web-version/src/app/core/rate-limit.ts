import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class RateLimit {
  private readonly DB_NAME = 'app_rl';
  private readonly DB_STORE = 'entries';
  private readonly DB_VERSION = 1;

  // ── Fingerprint ────────────────────────────────────────────────────────────

  /**
   * بيبني hash من خصائص الجهاز والمتصفح الثابتة.
   * مش بيستخدم IP (frontend مش بيقدر)، لكن بيجمع:
   * - userAgent, platform, language, timezone
   * - screen resolution & color depth
   * - hardware concurrency & device memory
   * - canvas fingerprint (طريقة رسم المتصفح فريدة لكل جهاز/GPU)
   * - WebGL renderer info
   */
  async getFingerprint(): Promise<string> {
    const parts: string[] = [];

    // Navigator basics
    parts.push(navigator.userAgent);
    parts.push(navigator.language);
    parts.push(navigator.platform ?? '');
    parts.push(String(navigator.hardwareConcurrency ?? 0));
    parts.push(String((navigator as any).deviceMemory ?? 0));

    // Timezone
    parts.push(Intl.DateTimeFormat().resolvedOptions().timeZone);

    // Screen
    parts.push(`${screen.width}x${screen.height}x${screen.colorDepth}`);

    // Canvas fingerprint
    parts.push(this._canvasFingerprint());

    // WebGL fingerprint
    parts.push(this._webglFingerprint());

    const raw = parts.join('||');
    return this._sha256(raw);
  }

  private _canvasFingerprint(): string {
    try {
      const c = document.createElement('canvas');
      c.width = 240;
      c.height = 60;
      const ctx = c.getContext('2d')!;
      ctx.textBaseline = 'alphabetic';
      ctx.fillStyle = '#f60';
      ctx.fillRect(125, 1, 62, 20);
      ctx.fillStyle = '#069';
      ctx.font = '14px Arial';
      ctx.fillText('Cwm fjordbank glyphs vext quiz 😀', 2, 15);
      ctx.fillStyle = 'rgba(102,204,0,0.7)';
      ctx.font = '11px Arial';
      ctx.fillText('Cwm fjordbank glyphs vext quiz 😀', 4, 35);
      return c.toDataURL();
    } catch {
      return 'canvas-na';
    }
  }

  private _webglFingerprint(): string {
    try {
      const c = document.createElement('canvas');
      const gl = c.getContext('webgl') as WebGLRenderingContext | null;
      if (!gl) return 'webgl-na';
      const dbg = gl.getExtension('WEBGL_debug_renderer_info');
      if (!dbg) return 'webgl-no-dbg';
      return [
        gl.getParameter(dbg.UNMASKED_VENDOR_WEBGL),
        gl.getParameter(dbg.UNMASKED_RENDERER_WEBGL),
      ].join('|');
    } catch {
      return 'webgl-err';
    }
  }

  private async _sha256(msg: string): Promise<string> {
    const buf = new TextEncoder().encode(msg);
    const hash = await crypto.subtle.digest('SHA-256', buf);
    return Array.from(new Uint8Array(hash))
      .map((b) => b.toString(16).padStart(2, '0'))
      .join('');
  }

  // ── Multi-Storage Helpers ──────────────────────────────────────────────────

  /** يحفظ في localStorage */
  private _lsSet(key: string, value: string) {
    try {
      localStorage.setItem(key, value);
    } catch {}
  }

  private _lsGet(key: string): string | null {
    try {
      return localStorage.getItem(key);
    } catch {
      return null;
    }
  }

  /** يحفظ في sessionStorage */
  private _ssSet(key: string, value: string) {
    try {
      sessionStorage.setItem(key, value);
    } catch {}
  }

  private _ssGet(key: string): string | null {
    try {
      return sessionStorage.getItem(key);
    } catch {
      return null;
    }
  }

  /** يحفظ في Cookie (صلاحية 7 أيام) */
  private _cookieSet(key: string, value: string, days = 7) {
    const exp = new Date(Date.now() + days * 864e5).toUTCString();
    document.cookie = `${key}=${encodeURIComponent(value)};expires=${exp};path=/;SameSite=Strict`;
  }

  private _cookieGet(key: string): string | null {
    const match = document.cookie.split('; ').find((r) => r.startsWith(`${key}=`));
    return match ? decodeURIComponent(match.split('=')[1]) : null;
  }

  /** يحفظ في IndexedDB */
  private _idbSet(key: string, value: string): Promise<void> {
    return new Promise((resolve) => {
      try {
        const req = indexedDB.open(this.DB_NAME, this.DB_VERSION);
        req.onupgradeneeded = (e) => {
          const db = (e.target as IDBOpenDBRequest).result;
          if (!db.objectStoreNames.contains(this.DB_STORE)) {
            db.createObjectStore(this.DB_STORE);
          }
        };
        req.onsuccess = (e) => {
          const db = (e.target as IDBOpenDBRequest).result;
          const tx = db.transaction(this.DB_STORE, 'readwrite');
          tx.objectStore(this.DB_STORE).put(value, key);
          tx.oncomplete = () => resolve();
          tx.onerror = () => resolve();
        };
        req.onerror = () => resolve();
      } catch {
        resolve();
      }
    });
  }

  private _idbGet(key: string): Promise<string | null> {
    return new Promise((resolve) => {
      try {
        const req = indexedDB.open(this.DB_NAME, this.DB_VERSION);
        req.onupgradeneeded = (e) => {
          const db = (e.target as IDBOpenDBRequest).result;
          if (!db.objectStoreNames.contains(this.DB_STORE)) {
            db.createObjectStore(this.DB_STORE);
          }
        };
        req.onsuccess = (e) => {
          const db = (e.target as IDBOpenDBRequest).result;
          try {
            const tx = db.transaction(this.DB_STORE, 'readonly');
            const getReq = tx.objectStore(this.DB_STORE).get(key);
            getReq.onsuccess = () => resolve(getReq.result ?? null);
            getReq.onerror = () => resolve(null);
          } catch {
            resolve(null);
          }
        };
        req.onerror = () => resolve(null);
      } catch {
        resolve(null);
      }
    });
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /**
   * يسجل إن المستخدم عمل submit دلوقتي.
   * بيحفظ timestamp + fingerprint في كل الأماكن الأربعة.
   */
  async recordSubmit(key: string) {
    const fp = await this.getFingerprint();
    const entry = JSON.stringify({ ts: Date.now(), fp });
    const fpKey = `${key}_fp`;

    this._lsSet(key, Date.now().toString());
    this._lsSet(fpKey, fp);

    this._ssSet(key, entry);

    this._cookieSet(key, entry);

    await this._idbSet(key, entry);
  }

  /**
   * بيرجع الوقت المتبقي (بالـ ms) قبل ما المستخدم يقدر يبعت تاني.
   * بيقرأ من كل الأماكن ويرجع أكبر قيمة (الأصعب للمستخدم يتجاوزها).
   *
   * @param key   نفس الـ key اللي استخدمته في recordSubmit
   * @param cooldownMs  مدة الانتظار (default 5 دقايق)
   */
  async getRemainingCooldown(key: string, cooldownMs = 300_000): Promise<number> {
    const fp = await this.getFingerprint();
    const fpKey = `${key}_fp`;
    const candidates: number[] = [];

    // ── localStorage ──
    const lsTs = this._lsGet(key);
    const lsFp = this._lsGet(fpKey);
    if (lsTs) {
      // لو الـ fingerprint مطابق أو مفيش fingerprint محفوز → عامله
      if (!lsFp || lsFp === fp) {
        candidates.push(cooldownMs - (Date.now() - Number(lsTs)));
      }
    }

    // ── sessionStorage ──
    const ssRaw = this._ssGet(key);
    if (ssRaw) {
      try {
        const { ts, fp: storedFp } = JSON.parse(ssRaw);
        if (!storedFp || storedFp === fp) {
          candidates.push(cooldownMs - (Date.now() - ts));
        }
      } catch {}
    }

    // ── Cookie ──
    const ckRaw = this._cookieGet(key);
    if (ckRaw) {
      try {
        const { ts, fp: storedFp } = JSON.parse(ckRaw);
        if (!storedFp || storedFp === fp) {
          candidates.push(cooldownMs - (Date.now() - ts));
        }
      } catch {}
    }

    // ── IndexedDB ──
    const idbRaw = await this._idbGet(key);
    if (idbRaw) {
      try {
        const { ts, fp: storedFp } = JSON.parse(idbRaw);
        if (!storedFp || storedFp === fp) {
          candidates.push(cooldownMs - (Date.now() - ts));
        }
      } catch {}
    }

    // بياخد أكبر قيمة متبقية (الأقوى)
    const max = Math.max(...candidates, 0);
    return max > 0 ? max : 0;
  }
}
