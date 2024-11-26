import { Routes } from '@angular/router';

import { LoginComponent } from './pages/login/login.component';
import { HomeComponent } from './pages/home/home.component';
import { AdminHomeComponent } from './pages/admin/home/home.component';
import {
  AuthGuard,
  redirectLoggedInTo,
  redirectUnauthorizedTo,
} from '@angular/fire/auth-guard';
import { ShopComponent } from './pages/shop/shop.component';
import { CartComponent } from './pages/cart/cart.component';

const redirectToShop = () => redirectUnauthorizedTo(['shop']);

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
        canActivate: [AuthGuard],
        data: { authGuardPipe: redirectToShop },
      },
    ],
  },
  {
    path: 'login',
    component: LoginComponent,
  },
];
