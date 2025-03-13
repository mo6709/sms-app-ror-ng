import { Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { of } from 'rxjs';
import { map, catchError, exhaustMap } from 'rxjs/operators';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import * as MessagesActions from './messages.actions';
import { Message } from './messages.types';

@Injectable()
export class MessagesEffects {
    loadMessages$ = createEffect(() =>
        this.actions$.pipe(
            ofType(MessagesActions.loadMessages),
            exhaustMap(() =>
                this.http.get<Message[]>(`${environment.apiUrl}/sms`).pipe(
                    map(messages => MessagesActions.loadMessagesSuccess({ messages })),
                    catchError(error => of(MessagesActions.loadMessagesFailure({ 
                        error: error.message || 'Failed to load messages' 
                    })))
                )
            )
        )
    );

    sendMessage$ = createEffect(() =>
        this.actions$.pipe(
            ofType(MessagesActions.sendMessage),
            exhaustMap(({ message }) =>
                this.http.post<Message>(`${environment.apiUrl}/sms`, { sms_params: message }).pipe(
                    map(response => MessagesActions.sendMessageSuccess({ message: response })),
                    catchError(error => of(MessagesActions.sendMessageFailure({ 
                        error: error.message || 'Failed to send message' 
                    })))
                )
            )
        )
    );

    constructor(
        private actions$: Actions,
        private http: HttpClient
    ) {}
}