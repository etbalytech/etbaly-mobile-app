import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';

@Component({
  selector: 'app-notfound',
  standalone: true,
  imports: [CommonModule, RouterModule, TranslateModule],
  templateUrl: './notfound.html',
  styleUrl: './notfound.scss',
})
export class Notfound {}
