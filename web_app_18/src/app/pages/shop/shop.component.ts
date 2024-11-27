import { Component, inject, Optional } from '@angular/core';
import { RouterLink, RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common';
import { addDoc, collectionData, Firestore } from '@angular/fire/firestore';
import { collection, CollectionReference } from 'firebase/firestore';
import { Observable } from 'rxjs';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { faCartPlus } from '@fortawesome/free-solid-svg-icons';

import { NavbarComponent } from '../../components/navbar/navbar.component';
import { ItemFormComponent } from '../../components/item-form/item-form.component';
import { CartItem, Item } from '../../types/items';
import { getAuth, onAuthStateChanged } from '@angular/fire/auth';

import { ToastrService } from 'ngx-toastr';
import { query, where, getDocs } from 'firebase/firestore';

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
  auth = getAuth();
  connectedUser: any;
  items$: Observable<Item[]>;
  cartItems$: Observable<CartItem[]>;
  itemCollection: CollectionReference;
  cartCollection: CollectionReference;

  faCartPlus = faCartPlus;

  constructor(private toastr: ToastrService) {
    this.itemCollection = collection(this.firestore, 'items');
    this.cartCollection = collection(this.firestore, 'carts');
    this.items$ = collectionData(this.itemCollection);
    this.cartItems$ = collectionData(this.cartCollection);
  }

  ngOnInit(): void {
    onAuthStateChanged(this.auth, (user) => {
      if (user) {
        this.connectedUser = user;
      } else {
        this.connectedUser = null;
      }
    });
  }

  addItemToCart(item: Item) {
    if (!this.connectedUser) {
      this.toastr.error('You need to be logged in to add items to the cart');
      return;
    }

    const cartItem = {
      ...item,
      userId: this.connectedUser?.uid,
      quantity: 1,
    };

    addDoc(this.cartCollection, cartItem);
  }
}
