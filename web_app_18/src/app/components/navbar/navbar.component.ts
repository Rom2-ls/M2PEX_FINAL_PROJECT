import { Component, OnInit, OnDestroy, Optional, inject } from '@angular/core';
import {
  Auth,
  authState,
  GoogleAuthProvider,
  onAuthStateChanged,
  signInWithPopup,
  signOut,
  User,
} from '@angular/fire/auth';
import { EMPTY, Observable, Subscription } from 'rxjs';
import { map } from 'rxjs/operators';
import { traceUntilFirst } from '@angular/fire/performance';
import { Router, RouterLink } from '@angular/router';
import { NgIf, AsyncPipe } from '@angular/common';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { faArrowRightFromBracket } from '@fortawesome/free-solid-svg-icons';
import {
  collection,
  CollectionReference,
  getDocs,
  query,
  where,
} from 'firebase/firestore';
import { collectionData, Firestore } from '@angular/fire/firestore';
import { CartItem } from '../../types/items';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styles: [],
  standalone: true,
  imports: [NgIf, RouterLink, AsyncPipe, FontAwesomeModule],
})
export class NavbarComponent implements OnInit, OnDestroy {
  private readonly userDisposable: Subscription | undefined;
  public readonly user: Observable<User | null> = EMPTY;
  private firestore: Firestore = inject(Firestore);
  cartCollection: CollectionReference;
  cartItems$: Observable<CartItem[]>;
  connectedUser: any;
  cartItemCount: number = 0;

  faArrowRightFromBracket = faArrowRightFromBracket;
  showLoginButton = false;
  showLogoutButton = false;

  constructor(@Optional() private auth: Auth, private router: Router) {
    if (auth) {
      this.user = authState(this.auth);
      this.userDisposable = authState(this.auth)
        .pipe(
          <any>traceUntilFirst('auth'),
          map((u) => !!u)
        )
        .subscribe((isLoggedIn: boolean) => {
          this.showLoginButton = !isLoggedIn;
          this.showLogoutButton = isLoggedIn;
        });
    }

    this.cartCollection = collection(this.firestore, 'carts');
    this.cartItems$ = collectionData(this.cartCollection, {
      idField: 'id',
    });
  }

  ngOnInit(): void {
    onAuthStateChanged(this.auth, async (user) => {
      if (user) {
        this.connectedUser = user;
        this.listenToCartUpdates();
      } else {
        this.connectedUser = null;
        this.cartItemCount = 0;
      }
    });
  }

  ngOnDestroy(): void {
    if (this.userDisposable) {
      this.userDisposable.unsubscribe();
    }
  }

  async loginWithGoogle() {
    const provider = new GoogleAuthProvider();
    await signInWithPopup(this.auth, provider);
    await this.router.navigate(['/']);
  }

  async logout() {
    return await signOut(this.auth);
  }

  listenToCartUpdates() {
    if (!this.connectedUser) {
      return;
    }

    const q = query(
      this.cartCollection,
      where('userId', '==', this.connectedUser.uid)
    );

    collectionData(q).subscribe((cartItems: CartItem[]) => {
      this.cartItemCount = cartItems.length;
    });
  }
}
