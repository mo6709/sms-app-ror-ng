import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { HttpClient, HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [FormsModule, CommonModule, HttpClientModule],
  template: `
    <div class="login-container">
      <form (ngSubmit)="onSubmit()">
        <h2>Login</h2>
        <div>
          <input type="email" [(ngModel)]="email" name="email" placeholder="Email" required>
        </div>
        <div>
          <input type="password" [(ngModel)]="password" name="password" placeholder="Password" required>
        </div>
        <button type="submit">Login</button>
      </form>
    </div>
  `,
  styles: [`
    .login-container {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }
    form {
      padding: 20px;
      border: 1px solid #ccc;
      border-radius: 5px;
      width: 300px;
    }
    h2 {
      text-align: center;
      margin-bottom: 20px;
    }
    input {
      width: 100%;
      padding: 8px;
      margin: 10px 0;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    button {
      width: 100%;
      padding: 10px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    button:hover {
      background-color: #0056b3;
    }
  `]
})
export class LoginComponent {
  email: string = '';
  password: string = '';
  error: string = '';

  constructor(private http: HttpClient, private router: Router) {}

  onSubmit() {
    console.log('Login attempt:', { email: this.email, password: this.password });
    const headers = { 'Content-Type': 'application/json' };

    this.http.post('http://localhost:3000/api/v1/auth/login', {
      user: { 
        email: this.email,
        password: this.password 
      }
    }, { headers }).subscribe({
      next: (response: any) => {
        localStorage.setItem('token', response.data.token);
        this.router.navigate(['/dashboard']);
      },
      error: (error) => {
        this.error = 'Login failed. Please check your credentials.';
      }
    });
  }
}
