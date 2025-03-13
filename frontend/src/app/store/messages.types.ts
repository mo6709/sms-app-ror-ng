export interface Message {
    id: string;
    to_number: string;
    message: string;
    status: 'queued' | 'sent' | 'delivered' | 'failed';
    created_at: string;
    updated_at: string;
}

export interface MessagesState {
    messages: Message[];
    loading: boolean;
    error: string | null;
}

export const initialMessagesState: MessagesState = {
    messages: [],
    loading: false,
    error: null
};