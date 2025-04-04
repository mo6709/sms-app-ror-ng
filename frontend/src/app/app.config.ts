// import { ApplicationConfig, isDevMode, provideZoneChangeDetection } from '@angular/core';
// import { provideRouter } from '@angular/router';
// import { provideHttpClient, withInterceptors } from '@angular/common/http';
// import { provideStore } from '@ngrx/store';
// import { provideEffects } from '@ngrx/effects';
// import { provideStoreDevtools } from '@ngrx/store-devtools';
// import { routes } from './app.routes';
// import { messagesReducer } from './store/messages.reducer';
// import { MessagesEffects } from './store/messages.effects';


// export const appConfig: ApplicationConfig = {
//   providers: [
//     provideZoneChangeDetection({ eventCoalescing: true }), 
//     provideRouter(routes),
//     provideHttpClient(),
//     provideStore({
//       messages: messagesReducer
//     }),
//     provideEffects([MessagesEffects]),
//     provideStoreDevtools({
//       maxAge: 25,
//       logOnly: !isDevMode(),
//       autoPause: true,
//       trace: false,
//       traceLimit: 75,
//     })
//   ]
// };

import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient } from '@angular/common/http';

import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }), 
    provideRouter(routes),
    provideHttpClient()
  ]
};