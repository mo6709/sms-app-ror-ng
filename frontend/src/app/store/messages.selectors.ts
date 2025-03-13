import { createFeatureSelector, createSelector } from '@ngrx/store';
import { MessagesState } from './messages.types';

export const selectMessagesState = createFeatureSelector<MessagesState>('messages');

export const selectAllMessages = createSelector(
    selectMessagesState,
    (state: MessagesState) => state.messages
);

export const selectMessagesLoading = createSelector(
    selectMessagesState,
    (state: MessagesState) => state.loading
);

export const selectMessagesError = createSelector(
    selectMessagesState,
    (state: MessagesState) => state.error
);