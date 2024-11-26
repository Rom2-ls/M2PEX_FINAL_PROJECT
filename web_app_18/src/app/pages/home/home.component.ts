import { Component } from '@angular/core';
import { RouterLink, RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common';

import { NavbarComponent } from '../../components/navbar/navbar.component';
import { ItemFormComponent } from '../../components/item-form/item-form.component';

@Component({
  selector: 'app-home',
  standalone: true,
  templateUrl: './home.component.html',
  imports: [
    RouterLink,
    RouterOutlet,
    NavbarComponent,
    ItemFormComponent,
    CommonModule,
  ],
})
export class HomeComponent {}
