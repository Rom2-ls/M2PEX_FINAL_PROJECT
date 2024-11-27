import { ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideFirebaseApp, initializeApp } from '@angular/fire/app';
import { getFirestore, provideFirestore } from '@angular/fire/firestore';
import { provideAuth, getAuth } from '@angular/fire/auth';
import { provideAnimations } from '@angular/platform-browser/animations';
import { provideToastr } from 'ngx-toastr';

import { routes } from './app.routes';
import { provideClientHydration } from '@angular/platform-browser';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideClientHydration(),
    provideFirebaseApp(() =>
      initializeApp({
        apiKey: 'AIzaSyBmLJ2sjJR7thiQ0FFe5BA3y4IzU0T4stI',
        authDomain: 'm2pex-final-project-2cb7f.firebaseapp.com',
        projectId: 'm2pex-final-project-2cb7f',
        storageBucket: 'm2pex-final-project-2cb7f.firebasestorage.app',
        messagingSenderId: '250305718339',
        appId: '1:250305718339:web:76065650f90131c9554cf6',
      })
    ),
    provideAnimations(),
    provideToastr({
      maxOpened: 1,
    }),
    provideFirestore(() => getFirestore()),
    provideAuth(() => getAuth()),
  ],
};
