import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SendMessageComponent } from './send-message/send-message.component';
import { MessageListComponent } from './message-list/message-list.component';
import { HeaderComponent } from '../header.component';
import { ManagerDashboard } from './manager-dashboard/manager-dashboard.component'

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [SendMessageComponent, MessageListComponent, ManagerDashboard, HeaderComponent, CommonModule],
  template: `
    <app-header></app-header>
    
    <div class="dashboard-container">
      <button (click)="toggleManagerMode()">
        Switch to {{ isManager ? 'User' : 'Manager' }} Mode
      </button>
      
      <h1>Dashboard</h1>
      <div *ngIf="isManager" class="manager-dashboard-layout">
        <app-manager-dashboard #managerDashboard></app-manager-dashboard>
      </div>

      <div *ngIf="!isManager" class="dashboard-layout">
        <app-send-message (messageSent)="onMessageSent()"></app-send-message>
        <app-message-list #messageList></app-message-list>
      </div>
    </div>
  `,
  styles: [`
    .dashboard-container {
      padding: 20px;
      max-width: 1200px;
      margin: 80px auto 0;  /* Added top margin to account for fixed header */
    }

    .dashboard-layout {
      display: grid;
      grid-template-columns: 1fr 2fr;
      gap: 30px;
      margin-top: 20px;
    }

    h1 {
      margin: 0 0 20px;
      color: #333;
    }

    @media (max-width: 768px) {
      .dashboard-layout {
        grid-template-columns: 1fr;
      }
    }
  `]
})
export class DashboardComponent {
  isManager = false;

  onMessageSent() {
    const messageList = document.querySelector('app-message-list') as any;
    if (messageList) {
      messageList.fetchMessages();
    }
  }

  toggleManagerMode() {
    this.isManager = !this.isManager;
  }
}
