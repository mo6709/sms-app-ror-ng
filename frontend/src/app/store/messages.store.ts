import { Injectable, signal, computed } from "@angular/core";
import { Message } from './messages.types';
import { MessagesApi } from '../API/messages.api';

@Injectable({ providedIn: 'root' })
export class MessagesStore {
    //State
    private state = signal({
        messages: [] as Message[],
        loading: false,
        error: null as string | null
    });

    //Radable state
    messages$ = computed(() => this.state().messages);
    loading$ = computed(() => this.state().loading);
    error$ = computed(() => this.state().error);

    constructor(private api: MessagesApi) {};

    //Actions
    async sendMessage(content: string) {}; 
}