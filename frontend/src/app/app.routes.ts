import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { RegisterComponent } from './components/register/register.component';
import { SmsDashboardComponent } from './components/sms-dashboard/sms-dashboard.component';
import { SendSmsComponent } from './components/send-sms/send-sms.component';
import { SmsHistoryComponent } from './components/sms-history/sms-history.component';

const routes: Routes = [
  { path: '', redirectTo: '/login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  { path: 'dashboard', component: SmsDashboardComponent },
  { path: 'send-sms', component: SendSmsComponent },
  { path: 'history', component: SmsHistoryComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
