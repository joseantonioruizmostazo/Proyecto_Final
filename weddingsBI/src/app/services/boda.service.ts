import { Injectable } from '@angular/core';
import { AngularFirestore, AngularFirestoreCollection, AngularFirestoreDocument } from 'angularfire2/firestore';
import { BodaInterface } from '../models/bodaInterface';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class BodaService {

  bodasCollection: AngularFirestoreCollection<BodaInterface>;
  bodas: Observable<BodaInterface[]>;
  bodaDoc: AngularFirestoreDocument<BodaInterface>;

  constructor(public afs: AngularFirestore) {

    this.bodasCollection = afs.collection<BodaInterface>('boda');
    this.bodas = this.bodasCollection.snapshotChanges().pipe(
      map(actions => actions.map(a => {
        const data = a.payload.doc.data() as BodaInterface;
        const id = a.payload.doc.id;
        return {id, ... data};
      }))
    )
   }

   getBodas() {
     return this.bodas;
   }

   
}
