import { Component, inject } from '@angular/core';
import { addDoc, collectionData, Firestore } from '@angular/fire/firestore';
import { collection, CollectionReference } from 'firebase/firestore';
import { Observable } from 'rxjs';
import {
  FormControl,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { CommonModule } from '@angular/common';
import { Item } from '../../types/items';

@Component({
  selector: 'app-item-form',
  templateUrl: './item-form.component.html',
  standalone: true,
  imports: [ReactiveFormsModule, CommonModule],
})
export class ItemFormComponent {
  private firestore: Firestore = inject(Firestore);
  itemCollection: CollectionReference;

  itemForm = new FormGroup({
    name: new FormControl('', Validators.required),
    description: new FormControl('', Validators.required),
    price: new FormControl('', [Validators.required, Validators.min(0)]),
    quantity: new FormControl('', [Validators.required, Validators.min(0)]),
  });

  constructor() {
    this.itemCollection = collection(this.firestore, 'items');
  }

  addItem() {
    console.log(this.itemForm.value);
    addDoc(this.itemCollection, this.itemForm.value);
    this.itemForm.reset();
  }
}
