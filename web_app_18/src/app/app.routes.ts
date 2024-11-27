import { Routes } from '@angular/router';

import { LoginComponent } from './pages/login/login.component';
import { HomeComponent } from './pages/home/home.component';
import { AdminHomeComponent } from './pages/admin/home/home.component';
import { ShopComponent } from './pages/shop/shop.component';
import { CartComponent } from './pages/cart/cart.component';
import { AdminGuard } from './guards/auth.guard';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'shop',
    pathMatch: 'full',
  },
  {
    path: '',
    component: HomeComponent,
    children: [
      {
        path: 'shop',
        component: ShopComponent,
      },
      {
        path: 'cart',
        component: CartComponent,
      },
      {
        path: 'admin',
        component: AdminHomeComponent,
        canActivate: [AdminGuard],
      },
    ],
  },
  {
    path: 'login',
    component: LoginComponent,
  },
];
