import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { MainComponent } from './main/main.component';
import { SplashComponent } from './splash/splash.component';
import { AngularFirestoreModule } from 'angularfire2/firestore';
import { AngularFireModule } from 'angularfire2';
import { AngularFireDatabaseModule } from '@angular/fire/database';
import { environment } from '../environments/environment';
import { AngularFirestore, FirestoreSettingsToken } from '@angular/fire/firestore';
import { BodaService } from './services/boda.service';



@NgModule({
  declarations: [
    AppComponent,
    MainComponent,
    SplashComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    AngularFireModule.initializeApp(environment.firebaseConfig, 'weddingsBI'),
    AngularFireDatabaseModule,
    AngularFirestoreModule
  ],
  providers: [BodaService, 
    AngularFirestore,
    { provide: FirestoreSettingsToken, useValue: {} }],
  bootstrap: [AppComponent]
})
export class AppModule { }
