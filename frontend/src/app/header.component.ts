import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { HttpClient, HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [CommonModule, HttpClientModule],
  template: `
    <header class="header">
      <div class="header-content">
        <h1 class="logo">SMS App</h1>
        <button class="logout-button" (click)="logout()">
          <span class="logout-icon">↪</span>
          Logout
        </button>
      </div>
    </header>
  `,
  styles: [`
    .header {
      background-color: #ffffff;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      padding: 1rem;
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      z-index: 1000;
    }

    .header-content {
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .logo {
      margin: 0;
      font-size: 1.5rem;
      color: #333;
    }

    .logout-button {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.5rem 1rem;
      background-color: #dc3545;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1rem;
      transition: background-color 0.2s;
    }

    .logout-button:hover {
      background-color: #c82333;
    }

    .logout-icon {
      font-size: 1.2rem;
      transform: rotate(180deg);
      display: inline-block;
    }
  `]
})
export class HeaderComponent {
  constructor(private http: HttpClient, private router: Router) {}

  logout() {
    const token = localStorage.getItem('token');
    if (!token) {
      this.router.navigate(['/login']);
      return;
    }

    this.http.delete('http://localhost:3000/api/v1/auth/logout', {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    }).subscribe({
      next: () => {
        localStorage.removeItem('token');
        this.router.navigate(['/login']);
      },
      error: (error) => {
        console.error('Logout error:', error);
        // Even if the server request fails, we'll remove the token and redirect
        localStorage.removeItem('token');
        this.router.navigate(['/login']);
      }
    });
  }
} 