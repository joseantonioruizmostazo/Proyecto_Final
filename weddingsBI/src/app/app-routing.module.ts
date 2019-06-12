import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AppComponent } from './app.component';
import { MainComponent } from './main/main.component';
import { SplashComponent } from './splash/splash.component';

const routes: Routes = [
  {path: '', component: SplashComponent },
  {path: 'splash', component: SplashComponent },
  {path: 'main', component: MainComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
