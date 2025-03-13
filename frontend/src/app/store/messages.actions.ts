import { createAction, props } from '@ngrx/store';
import { Message } from './messages.types';

export const loadMessages = createAction(
    '[Messages] Load Messages'
);

export const loadMessagesSuccess = createAction(
    '[Messages] Load Messages Success',
    props<{ messages: Message[] }>()
);

export const loadMessagesFailure = createAction(
    '[Messages] Load Messages Failure',
    props<{ error: string }>()
);

export const sendMessage = createAction(
    '[Messages] Send Message',
    props<{ message: { to_number: string; message: string } }>()
);

export const sendMessageSuccess = createAction(
    '[Messages] Send Message Success',
    props<{ message: Message }>()
);

export const sendMessageFailure = createAction(
    '[Messages] Send Message Failure',
    props<{ error: string }>()
);