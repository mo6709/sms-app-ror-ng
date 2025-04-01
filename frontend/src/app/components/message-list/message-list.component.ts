import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-message-list',
  standalone: true,
  imports: [CommonModule, HttpClientModule],
  template: `
    <div class="messages-section">
      <div class="messages-header">
        <h2>Message History</h2>
        <button class="refresh-button" (click)="fetchMessages()" [disabled]="loading">
          <span class="refresh-icon" [class.spinning]="loading">↻</span>
          {{ loading ? 'Refreshing...' : 'Refresh' }}
        </button>
      </div>
      
      <div *ngIf="loading" class="loading">Loading messages...</div>
      
      <div *ngIf="error" class="error">{{ error }}</div>

      <div *ngIf="!loading && messages.length === 0" class="no-messages">
        No messages found
      </div>

      <div *ngIf="messages.length > 0" class="messages-list">
        <div *ngFor="let message of messages" class="message-card">
          <div class="message-header">
            <span class="to-number">To: {{ message.to_number }}</span>
            <span class="status" [class.status-sent]="message.status === 'sent'">
              Status: {{ message.status }}
            </span>
            <button (click)="onDelete(message._id)" class="delete-button">
              Delete
            </button>
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
    .messages-section {
      min-height: 400px;
    }

    .messages-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    .refresh-button {
      display: flex;
      align-items: center;
      gap: 5px;
      padding: 8px 16px;
      background-color: #6c757d;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 14px;
    }

    .refresh-button:disabled {
      background-color: #ccc;
      cursor: not-allowed;
    }

    .refresh-icon {
      display: inline-block;
      font-size: 16px;
    }

    .spinning {
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      from { transform: rotate(0deg); }
      to { transform: rotate(360deg); }
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

    .loading {
      text-align: center;
      color: #666;
      padding: 20px;
    }

    .error {
      color: red;
      margin: 10px 0;
      padding: 10px;
      background-color: #ffebee;
      border-radius: 4px;
    }

    .status-sent {
      color: #28a745;
    }

    h2 {
      margin: 0;
      color: #333;
    }
  `]
})
export class MessageListComponent implements OnInit, OnDestroy {
  // private store = inject(MessagesStore);

  messages: any[] = []; //this.store.messages$;
  loading: boolean = true; //this.store.loading$;
  error: string = ''; //this.store.error$;
  private refreshInterval: any;

  constructor(private http: HttpClient, private router: Router) {}

  ngOnInit() {
    this.fetchMessages();
    this.refreshInterval = setInterval(() => {
      this.fetchMessages();
    }, 30000);
  }

  ngOnDestroy() {
    if (this.refreshInterval) {
      clearInterval(this.refreshInterval);
    }
  }

  fetchMessages() {
    this.loading = true;
    this.error = '';
    
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
        this.error = 'Failed. Try again latter.';
        this.loading = false;
        if (error.status === 401) {
          localStorage.removeItem('token');
          this.router.navigate(['/login']);
        }
        console.error('Error fetching messages:', error);
      }
    });
  }

  onDelete(id: string) {
    const token = localStorage.getItem('token');
    // if (!token) {
    //   this.router.navigate(['/login']);
    //   return;
    // }

    this.http.delete(`http://localhost:3000/api/v1/sms/${id}`,{
        headers: {
          'Authorization': `Bearer ${token}`
        }
    }).subscribe({
      next: (response: any) => {
        console.log("Message deleted successfully")
      }
    })
  }
} 