import { CommonModule } from '@angular/common'
import { Component, OnInit, OnDestroy, inject } from '@angular/core'
import { Router } from '@angular/router'

@Component({
    selector: 'app-manager-dashboard',
    standalone: true,
    imports: [CommonModule],
    template: `
    <div>
        <h2>Manager Dashboard</h2>
        
    </div>
    `,
    styles: `
        h2 {
            margin: 0;
            color: #333;
        }
    `
})
export class ManagerDashboard {
    constructor(private router: Router) {}
}