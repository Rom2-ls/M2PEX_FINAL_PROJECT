import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';
import { ItemFormComponent } from '../../../components/item-form/item-form.component';

@Component({
  selector: 'app-admin-home',
  standalone: true,
  templateUrl: './home.component.html',
  imports: [RouterLink, ItemFormComponent, CommonModule],
})
export class AdminHomeComponent {}
