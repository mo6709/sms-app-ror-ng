import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { SMS } from '../models/sms';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class SmsService {
  private apiUrl = `${environment.apiUrl}/sms`;

  constructor(private http: HttpClient) { }

  sendSMS(sms: SMS): Observable<any> {
    return this.http.post(`${this.apiUrl}/send`, sms);
  }

  getHistory(): Observable<SMS[]> {
    return this.http.get<SMS[]>(`${this.apiUrl}/history`);
  }
}
