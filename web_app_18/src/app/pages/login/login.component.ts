import { Component, Optional } from '@angular/core';
import { Auth, GoogleAuthProvider } from '@angular/fire/auth';
import { RouterLink, Router } from '@angular/router';
import { signInWithPopup } from 'firebase/auth';

@Component({
  selector: 'app-login',
  standalone: true,
  templateUrl: './login.component.html',
  imports: [RouterLink],
})
export class LoginComponent {
  constructor(@Optional() private auth: Auth, private router: Router) {}

  async loginWithGoogle() {
    const provider = new GoogleAuthProvider();
    await signInWithPopup(this.auth, provider);
    await this.router.navigate(['/']);
  }
}
