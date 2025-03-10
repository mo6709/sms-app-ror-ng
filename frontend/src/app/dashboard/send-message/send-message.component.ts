import { Component, EventEmitter, Output } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-send-message',
  standalone: true,
  imports: [FormsModule, CommonModule, HttpClientModule],
  template: `
    <div class="send-message-section">
      <h2>Send New Message</h2>
      <form (ngSubmit)="sendMessage()" #messageForm="ngForm" class="message-form">
        <div class="form-group">
          <label for="toNumber">To Number:</label>
          <input 
            type="text" 
            id="toNumber" 
            name="toNumber"
            [(ngModel)]="newMessage.to_number"
            required
            placeholder="Enter phone number"
            class="form-control"
          >
        </div>
        
        <div class="form-group">
          <label for="message">Message:</label>
          <textarea 
            id="message" 
            name="message"
            [(ngModel)]="newMessage.message"
            required
            placeholder="Type your message"
            class="form-control"
            rows="4"
          ></textarea>
        </div>

        <button type="submit" [disabled]="!messageForm.form.valid || sending">
          {{ sending ? 'Sending...' : 'Send Message' }}
        </button>

        <div *ngIf="sendError" class="error">
          {{ sendError }}
        </div>
      </form>
    </div>
  `,
  styles: [`
    .send-message-section {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 8px;
      height: fit-content;
    }

    .message-form {
      display: flex;
      flex-direction: column;
      gap: 15px;
    }

    .form-group {
      display: flex;
      flex-direction: column;
      gap: 5px;
    }

    .form-control {
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }

    textarea.form-control {
      resize: vertical;
      min-height: 100px;
    }

    button {
      padding: 10px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
    }

    button:disabled {
      background-color: #ccc;
      cursor: not-allowed;
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
export class SendMessageComponent {
  @Output() messageSent = new EventEmitter<void>();

  sending: boolean = false;
  sendError: string = '';
  
  newMessage = {
    to_number: '',
    message: ''
  };

  constructor(private http: HttpClient, private router: Router) {}

  sendMessage() {
    this.sending = true;
    this.sendError = '';
    
    const token = localStorage.getItem('token');
    if (!token) {
      this.router.navigate(['/login']);
      return;
    }

    this.http.post('http://localhost:3000/api/v1/sms', 
      { sms_params: this.newMessage },
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    ).subscribe({
      next: (response: any) => {
        this.sending = false;
        this.newMessage = {
          to_number: '',
          message: ''
        };
        this.messageSent.emit();
      },
      error: (error) => {
        this.sending = false;
        this.sendError = 'Failed to send message. Please try again.';
        if (error.status === 401) {
          localStorage.removeItem('token');
          this.router.navigate(['/login']);
        }
        console.error('Error sending message:', error);
      }
    });
  }
} 