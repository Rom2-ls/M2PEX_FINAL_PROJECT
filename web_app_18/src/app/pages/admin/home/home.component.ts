import { Component, inject, Optional } from '@angular/core';
import { RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';
import { ItemFormComponent } from '../../../components/item-form/item-form.component';

import {
  collectionData,
  deleteDoc,
  doc,
  Firestore,
  updateDoc,
} from '@angular/fire/firestore';
import { collection, CollectionReference } from 'firebase/firestore';
import { Observable } from 'rxjs';

import { Auth } from '@angular/fire/auth';
import { Item } from '../../../types/items';
import {
  FormControl,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';

@Component({
  selector: 'app-admin-home',
  standalone: true,
  templateUrl: './home.component.html',
  imports: [RouterLink, ItemFormComponent, CommonModule, ReactiveFormsModule],
})
export class AdminHomeComponent {
  private firestore: Firestore = inject(Firestore);
  items$: Observable<Item[]>;
  itemCollection: CollectionReference;
  forms: { [key: string]: FormGroup } = {};

  constructor(@Optional() private auth: Auth) {
    this.itemCollection = collection(this.firestore, 'items');
    this.items$ = collectionData(this.itemCollection, {
      idField: 'id',
    });

    this.items$.subscribe((items) => {
      items.forEach((item) => {
        this.forms[item.id] = new FormGroup({
          name: new FormControl(item.name, Validators.required),
          description: new FormControl(item.description, Validators.required),
          price: new FormControl(item.price, [
            Validators.required,
            Validators.min(0),
          ]),
          quantity: new FormControl(item.quantity, [
            Validators.required,
            Validators.min(0),
          ]),
        });
      });
    });
  }

  updateItem(item: Item) {
    const form = this.forms[item.id];
    if (form.valid) {
      const updatedItem = { ...item, ...form.value };
      const itemDoc = doc(this.firestore, `items/${item.id}`);
      updateDoc(itemDoc, updatedItem);
    }
  }

  deleteItem(id: string) {
    const itemDoc = doc(this.firestore, `items/${id}`);
    deleteDoc(itemDoc);
  }
}
