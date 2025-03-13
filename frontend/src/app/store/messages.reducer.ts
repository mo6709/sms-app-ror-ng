import { createReducer, on } from '@ngrx/store';
import { MessagesState, initialMessagesState } from './messages.types';
import * as MessagesActions from './messages.actions';

export const messagesReducer = createReducer(
    initialMessagesState,
    
    on(MessagesActions.loadMessages, (state) => ({
        ...state,
        loading: true,
        error: null
    })),
    
    on(MessagesActions.loadMessagesSuccess, (state, { messages }) => ({
        ...state,
        messages,
        loading: false,
        error: null
    })),
    
    on(MessagesActions.loadMessagesFailure, (state, { error }) => ({
        ...state,
        loading: false,
        error
    })),
    
    on(MessagesActions.sendMessage, (state) => ({
        ...state,
        loading: true,
        error: null
    })),
    
    on(MessagesActions.sendMessageSuccess, (state, { message }) => ({
        ...state,
        messages: [message, ...state.messages],
        loading: false,
        error: null
    })),
    
    on(MessagesActions.sendMessageFailure, (state, { error }) => ({
        ...state,
        loading: false,
        error
    }))
);