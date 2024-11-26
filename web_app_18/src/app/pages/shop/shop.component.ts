import { Component, inject, Optional } from '@angular/core';
import { RouterLink, RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common';
import { collectionData, Firestore } from '@angular/fire/firestore';
import { addDoc, collection, CollectionReference } from 'firebase/firestore';
import { Observable } from 'rxjs';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { faCartPlus } from '@fortawesome/free-solid-svg-icons';

import { NavbarComponent } from '../../components/navbar/navbar.component';
import { ItemFormComponent } from '../../components/item-form/item-form.component';
import { Item } from '../../types/items';
import { Auth, onAuthStateChanged, User } from '@angular/fire/auth';
import { map } from 'rxjs/operators';

@Component({
  selector: 'app-shop',
  standalone: true,
  templateUrl: './shop.component.html',
  imports: [
    RouterLink,
    RouterOutlet,
    NavbarComponent,
    ItemFormComponent,
    CommonModule,
    FontAwesomeModule,
  ],
})
export class ShopComponent {
  private firestore: Firestore = inject(Firestore);
  user: any;
  items$: Observable<Item[]>;
  itemCollection: CollectionReference;
  cartCollection: CollectionReference;

  faCartPlus = faCartPlus;

  constructor(@Optional() private auth: Auth) {
    this.itemCollection = collection(this.firestore, 'items');
    this.cartCollection = collection(this.firestore, 'carts');
    this.items$ = collectionData(this.itemCollection);
  }

  ngOnInit() {
    onAuthStateChanged(this.auth, (user: any) => {
      if (user) {
        this.user = user;
      }
    });
  }

  addItemToCart(item: Item) {
    console.log('Added item to cart', item);

    console.log('User', this.user);

    const cartItem = {
      ...item,
      userId: this.user?.uid,
      quantity: 1,
    };

    console.log('Cart item', cartItem);

    // addDoc(this.cartCollection, cartItem);
  }
}

export interface CartItem extends Item {
  userId: string;
  quantity: number;
}
