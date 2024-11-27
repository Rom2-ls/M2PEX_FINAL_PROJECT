import { Injectable } from '@angular/core';
import { CanActivate, Router, UrlTree } from '@angular/router';
import { Auth } from '@angular/fire/auth';
import {
  Firestore,
  collection,
  query,
  where,
  getDocs,
} from '@angular/fire/firestore';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class AdminGuard implements CanActivate {
  constructor(
    private auth: Auth,
    private router: Router,
    private firestore: Firestore
  ) {}

  canActivate(): Observable<boolean | UrlTree> {
    return new Observable((observer) => {
      this.auth.onAuthStateChanged(async (user) => {
        if (user) {
          try {
            const rolesRef = collection(this.firestore, 'roles');
            const q = query(rolesRef, where('userId', '==', user.uid));
            const querySnapshot = await getDocs(q);

            if (!querySnapshot.empty) {
              const roleDoc = querySnapshot.docs[0].data();

              console.log('Role:', roleDoc);
              if (roleDoc['role'] === 'ADMIN') {
                observer.next(true);
                return;
              }
            }

            this.router.navigate(['/shop']);
            observer.next(false);
          } catch (error) {
            this.router.navigate(['/shop']);
            observer.next(false);
          }
        } else {
          this.router.navigate(['/shop']);
          observer.next(false);
        }
      });
    });
  }
}
