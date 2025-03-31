import { CommonModule } from '@angular/common'
import { Component, OnInit, OnDestroy, inject } from '@angular/core'
import { Router } from '@angular/router'

interface ManagerState {
    managerInfo: {
        name: string;
        role: string;
    };
    managerData: {
        usersToApprove: Array<{
            id: string,
            status: string,
            approvalCount: number
        }>
    };
    loading: boolean;
    errors: string;
}

@Component({
    selector: 'app-manager-dashboard',
    standalone: true,
    imports: [CommonModule],
    template: `
    <div>
        <h2>Manager Dashboard</h2>
        <div class="manager-info" *ngIf="state">      
        Name: <h3>{{ state.managerInfo.name }}</h3>
        Role: <h3>{{ state.managerInfo.role }}</h3>
        </div>
        
        <ng-container *ngIf="state && !state.loading">
            <div class="UsersNeededApproval" *ngIf="state?.managerData?.usersToApprove || []">
                <div *ngFor="let user of state.managerData.usersToApprove">
                    <div class="user-info">
                        <span class="user-id">{{ user.id }}</span>
                        <span class="user-status">{{ user.status }}</span>
                        <span class="user-approval-count">{{ user.approvalCount }}</span>
                    </div>
                </div>
            </div>
        </ng-container>
        <div class="UserApprovalForm">
        </div>
    </div>
    `,
    styles: `
        h2 {
            margin: 0;
            color: #333;
        }
    `
})
export class ManagerDashboard implements OnInit {
    state: ManagerState | null = null ; 

    constructor(private router: Router) {}

    ngOnInit() {
        this.fetchManagerData();
    }

    fetchManagerData() {
        const token = localStorage.getItem('token');
        if (!token){
            this.router.navigate(['/login']);
            return
        }

        this.state = {
            managerInfo: { name: "Joe Lee", role: "Admin" },
            managerData: {
                usersToApprove: [
                    {id: "13124q2sa43124", status: "pending", approvalCount: 1},
                    {id: "98msndu8372", status: "pending", approvalCount: 0},
                    {id: "jsd7sby2jh1b2", status: "pending", approvalCount: 0},
                ]
            },
            loading: false,
            errors: '',   
        }

        // this.http.get('http://localhost:3000/api/v1/manager_approvals/19', {
        //     headers: { 'Authorization': `Bearer ${token}`}
        // }).subscribe({
        //     next: (response: any) => {
        //         this.managerData = {}
        //     },
        //     error: (error) => {}
        // })
    }
}