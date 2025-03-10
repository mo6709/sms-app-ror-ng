import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { HttpClient, HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [FormsModule, CommonModule, HttpClientModule],
  template: `
    <div class="dashboard-container">
      <h1>Dashboard</h1>
      
      <div *ngIf="loading">Loading messages...</div>
      
      <div *ngIf="error" class="error">{{ error }}</div>

      <div *ngIf="!loading && messages.length === 0" class="no-messages">
        No messages found
      </div>

      <div *ngIf="messages.length > 0" class="messages-list">
        <div *ngFor="let message of messages" class="message-card">
          <div class="message-header">
            <span class="to-number">To: {{ message.to_number }}</span>
            <span class="status">Status: {{ message.status }}</span>
          </div>
          <div class="message-body">{{ message.message }}</div>
          <div class="message-footer">
            <span class="date">{{ message.created_at | date:'medium' }}</span>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .dashboard-container {
      padding: 20px;
      max-width: 800px;
      margin: 0 auto;
    }
    .message-card {
      border: 1px solid #ddd;
      border-radius: 8px;
      padding: 15px;
      margin-bottom: 15px;
      background-color: white;
    }
    .message-header {
      display: flex;
      justify-content: space-between;
      margin-bottom: 10px;
      color: #666;
    }
    .message-body {
      font-size: 16px;
      margin-bottom: 10px;
    }
    .message-footer {
      font-size: 12px;
      color: #888;
    }
    .error {
      color: red;
      margin: 10px 0;
      padding: 10px;
      background-color: #ffebee;
      border-radius: 4px;
    }
  `]
})
export class DashboardComponent implements OnInit {
  messages: any[] = [];
  loading: boolean = true;
  error: string = '';

  constructor(private http: HttpClient, private router: Router) {}

  ngOnInit() {
    this.fetchMessages();
  }

  fetchMessages() {
    const token = localStorage.getItem('token');
    if (!token) {
      this.router.navigate(['/login']);
      return;
    }

    this.http.get('http://localhost:3000/api/v1/sms', {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    }).subscribe({
      next: (response: any) => {
        this.messages = response;
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Failed to fetch messages. Please try again later.';
        this.loading = false;
        if (error.status === 401) {
          localStorage.removeItem('token');
          this.router.navigate(['/login']);
        }
        console.error('Error fetching messages:', error);
      }
    });
  }
}
