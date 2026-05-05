import { Injectable, inject } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { Router, NavigationEnd, ActivatedRoute } from '@angular/router';
import { filter } from 'rxjs';
import { TranslateService } from '@ngx-translate/core';

@Injectable({ providedIn: 'root' })
export class PageTitleService {
  private title = inject(Title);
  private router = inject(Router);
  private route = inject(ActivatedRoute);
  private translate = inject(TranslateService);

  init() {
    this.router.events.pipe(filter((event) => event instanceof NavigationEnd)).subscribe(() => {
      let child = this.route.firstChild;

      while (child?.firstChild) {
        child = child.firstChild;
      }

      const key = child?.snapshot.data['title'];

      if (key) {
        this.translate.get(key).subscribe((t) => this.title.setTitle(t));
      }
    });
  }
}
