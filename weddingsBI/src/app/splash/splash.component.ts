import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-splash',
  templateUrl: './splash.component.html',
  styleUrls: ['./splash.component.scss']
})
export class SplashComponent implements OnInit {

  constructor(private router: Router) { }

  title = 'WEDDINGS BUSSINES INTELLIGENCE';


  ngOnInit() {

    setTimeout(() => {
      this.router.navigate(['main']);
    }, 20000);

  }

}

  
    


