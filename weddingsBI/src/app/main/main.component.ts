import { Component, OnInit } from '@angular/core';
import { BodaInterface } from '../models/bodaInterface';
import { BodaService } from '../services/boda.service';
import { Chart } from 'chart.js'
import { sanitizeHtml } from '@angular/core/src/sanitization/sanitization';

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit {

  arrBodas: BodaInterface[];
  ciudades = [];
  meses = [];
  anyos = [];
  invitados = [];
  sumInvitados = 0;
  avgInvitados = 0;
  numBodas = 0;

  // Variables de ciudades (número de bodas en cada ciudad)
  alava: number = 0; albacete: number = 0; alicante: number = 0;
  almeria: number = 0; asturias: number = 0; avila: number = 0;
  badajoz: number = 0; barcelona: number = 0; burgos: number = 0;
  caceres: number = 0; cadiz: number = 0; cantabria: number = 0;
  castellon: number = 0; ciudadReal: number = 0; cordoba: number = 0;
  aCorunya: number = 0; cuenca: number = 0; gerona: number = 0;
  granada: number = 0; guadalajara: number = 0; guipuzcua: number = 0;
  huelva: number = 0; huesca: number = 0; islasBaleares: number = 0;
  jaen: number = 0; leon: number = 0; lerida: number = 0;
  lugo: number = 0; madrid: number = 0; malaga: number = 0;
  murcia: number = 0; navarra: number = 0; ourense: number = 0;
  palencia: number = 0; lasPalmas: number = 0; pontevedra: number = 0;
  laRioja: number = 0; salamanca: number = 0; segovia: number = 0;
  sevilla: number = 0; soria: number = 0; tarragona: number = 0;
  santaCruzDeTenerife: number = 0; teruel: number = 0; toledo: number = 0;
  valencia: number = 0; valladolid: number = 0; vizcaya: number = 0;
  zamora: number = 0; zaragoza: number = 0;

  // Variables de meses (número de bodas en cada mes)
  enero: number = 0; febrero: number = 0; marzo: number = 0;
  abril: number = 0; mayo: number = 0; junio: number = 0;
  julio: number = 0; agosto: number = 0; septiembre: number = 0;
  octubre: number = 0; noviembre: number = 0; diciembre: number = 0;

  // Variables de meses (número de bodas en cada mes)
  dosMilDiecinueve: number = 0; dosMilVeinte: number = 0; dosMilVeintiuno: number = 0;
  dosMilVeintidos: number = 0; dosMilVeintitres: number = 0;
  
  constructor(private bodaService: BodaService) { }

  title = 'WEDDINGS BUSSINES INTELLIGENCE';
  
  barChart = [];
  barChart2 = [];
  pieChart = [];
  
  ngOnInit() {
    this.bodaService.getBodas().subscribe(bodas => {
      console.log(bodas);
      this.arrBodas = bodas;
      console.log(this.arrBodas["0"].Ciudad);

      for (let i = 0; i < this.arrBodas.length; i++) {
        this.ciudades.push(this.arrBodas[i].Ciudad);
        this.meses.push(this.arrBodas[i].FechaBoda.slice(3,5));
        this.anyos.push(this.arrBodas[i].FechaBoda.slice(6,10));
        this.invitados.push(parseInt(this.arrBodas[i].Invitados));
        //console.log(this.arrBodas[i].Ciudad);
      }
      this.numBodas = this.arrBodas.length;
      this.sumInvitados = this.invitados.reduce((previous, current) => current += previous);
      this.avgInvitados = Math.round(this.sumInvitados / this.invitados.length);
      console.log(this.avgInvitados);

      for (let i = 0; i < this.ciudades.length; i++) {
      
        switch (this.ciudades[i]) {
          case 'Álava': this.alava += 1; break;
          case 'Albacete': this.albacete += 1; break;
          case 'Alicante': this.alicante += 1; break;
          case 'Almería': this.almeria += 1; break;
          case 'Asturias': this.asturias += 1; break;
          case 'Ávila': this.avila += 1; break;
          case 'Badajoz': this.badajoz += 1; break;
          case 'Barcelona': this.barcelona += 1; break;
          case 'Burgos': this.burgos += 1; break;
          case 'Cáceres': this.caceres += 1; break;
          case 'Cádiz': this.cadiz += 1; break;
          case 'Cantabria': this.cantabria += 1; break;
          case 'Castellón': this.castellon += 1; break;
          case 'Ciudad Real': this.ciudadReal += 1; break;
          case 'Córdoba': this.cordoba += 1; break;
          case 'A Coruña': this.aCorunya += 1; break;
          case 'Cuenca': this.cuenca += 1; break;
          case 'Gerona': this.gerona += 1; break;
          case 'Granada': this.granada += 1; break;
          case 'Guadalajara': this.guadalajara += 1; break;
          case 'Guipúzcoa': this.guipuzcua += 1; break;
          case 'Huelva': this.huelva += 1; break;
          case 'Huesca': this.huesca += 1; break;
          case 'Islas Baleares': this.islasBaleares += 1; break;
          case 'Jaén': this.jaen += 1; break;
          case 'León': this.leon += 1; break;
          case 'Lérida': this.lerida += 1; break;
          case 'Lugo': this.lugo += 1; break;
          case 'Madrid': this.madrid += 1; break;
          case 'Málaga': this.malaga += 1; break;
          case 'Murcia': this.murcia += 1; break;
          case 'Navarra': this.navarra += 1; break;
          case 'Ourense': this.ourense += 1; break;
          case 'Palencia': this.palencia += 1; break;
          case 'Las Palmas': this.lasPalmas += 1; break;
          case 'Pontevedra': this.pontevedra += 1; break;
          case 'La Rioja': this.laRioja += 1; break;
          case 'Salamanca': this.salamanca += 1; break;
          case 'Segovia': this.segovia += 1; break;
          case 'Sevilla': this.sevilla += 1; break;
          case 'Soria': this.soria += 1; break;
          case 'Tarragona': this.tarragona += 1; break;
          case 'Santa Cruz de Tenerife': this.santaCruzDeTenerife += 1; break;
          case 'Teruel': this.teruel += 1; break;
          case 'Toledo': this.toledo += 1; break;
          case 'Valencia': this.valencia += 1; break;
          case 'Valladolid': this.valladolid += 1; break;
          case 'Vizcaya': this.vizcaya += 1; break;
          case 'Zamora': this.zamora += 1; break;
          case 'Zaragoza': this.zaragoza += 1; break;
          default:
            //Sentencias_def ejecutadas cuando no ocurre una coincidencia con los anteriores casos
            break;
        } 

        switch (this.meses[i]) {
          case '01': this.enero += 1; break;
          case '02': this.febrero += 1; break;
          case '03': this.marzo += 1; break;
          case '04': this.abril += 1; break;
          case '05': this.mayo += 1; break;
          case '06': this.junio += 1; break;
          case '07': this.julio += 1; break;
          case '08': this.agosto += 1; break;
          case '09': this.septiembre += 1; break;
          case '10': this.octubre += 1; break;
          case '11': this.noviembre += 1; break;
          case '12': this.diciembre += 1; break;
          default:
            //Sentencias_def ejecutadas cuando no ocurre una coincidencia con los anteriores casos
            break;
        }

        switch (this.anyos[i]) {
          case '2019': this.dosMilDiecinueve += 1; break;
          case '2020': this.dosMilVeinte += 1; break;
          case '2021': this.dosMilVeintiuno += 1; break;
          case '2022': this.dosMilVeintidos += 1; break;
          case '2023': this.dosMilVeintitres += 1; break;
          default:
            //Sentencias_def ejecutadas cuando no ocurre una coincidencia con los anteriores casos
            break;
        }
      }
      this.getCharts();
    }); 


    
  }

  getCharts() {
    this.barChart = new Chart('barChart', {
      type: 'bar',
      data: {
        labels: ['Álava','Albacete','Alicante','Almería','Asturias','Ávila','Badajoz','Barcelona','Burgos','Cáceres',
        'Cádiz','Cantabria','Castellón','Ciudad Real','Córdoba','A Coruña','Cuenca','Gerona','Granada','Guadalajara',
        'Guipúzcoa','Huelva','Huesca','Islas Baleares','Jaén','León','Lérida','Lugo','Madrid','Málaga','Murcia','Navarra',
        'Ourense','Palencia','Las Palmas','Pontevedra','La Rioja','Salamanca','Segovia','Sevilla','Soria','Tarragona',
        'Santa Cruz de Tenerife','Teruel','Toledo','Valencia','Valladolid','Vizcaya','Zamora','Zaragoza'],
        datasets: [{
          label: 'WEDDINGS',
          data: [this.alava, this.albacete, this.alicante, this.almeria, this.asturias, this.avila, this.badajoz,
            this.barcelona, this.burgos, this.caceres, this.cadiz, this.cantabria, this.castellon, this.ciudadReal,
            this.cordoba, this.aCorunya, this.cuenca, this.gerona, this.granada, this.guadalajara, this.guipuzcua,
            this.huelva, this.huesca, this.islasBaleares, this.jaen, this.leon, this.lerida, this.lugo, this.madrid,
            this.malaga, this.murcia, this.navarra, this.ourense, this.palencia, this.lasPalmas, this.pontevedra,
            this.laRioja, this.salamanca, this.segovia, this.sevilla, this.soria, this.tarragona, this.santaCruzDeTenerife,
            this.teruel, this.toledo, this.valencia, this.valladolid, this.vizcaya, this.zamora, this.zaragoza],
          backgroundColor: [
            'rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)','rgba(153, 102, 255, 0.2)',
            'rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)','rgba(153, 102, 255, 0.2)',
            'rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)','rgba(153, 102, 255, 0.2)',
            'rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)','rgba(153, 102, 255, 0.2)',
            'rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)','rgba(153, 102, 255, 0.2)',
            'rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)','rgba(153, 102, 255, 0.2)',
            'rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)','rgba(153, 102, 255, 0.2)',
            'rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)','rgba(153, 102, 255, 0.2)',
            'rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)','rgba(153, 102, 255, 0.2)',
            'rgba(255, 99, 132, 0.2)', 'rgba(54, 162, 235, 0.2)', 'rgba(255, 206, 86, 0.2)', 'rgba(75, 192, 192, 0.2)','rgba(153, 102, 255, 0.2)',
          ],
          borderColor: [
            'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)','rgba(255, 159, 64, 1)',
            'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)','rgba(255, 159, 64, 1)',
            'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)','rgba(255, 159, 64, 1)',
            'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)','rgba(255, 159, 64, 1)',
            'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)','rgba(255, 159, 64, 1)',
            'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)','rgba(255, 159, 64, 1)',
            'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)','rgba(255, 159, 64, 1)',
            'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)','rgba(255, 159, 64, 1)',
            'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)','rgba(255, 159, 64, 1)',
            'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)','rgba(255, 159, 64, 1)',
          ],
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero: true
            }
          }]
        }
      }
    });


    this.barChart2 = new Chart('barChart2', {
      type: 'bar',
      data: {
        labels: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre',
      'Octubre', 'Noviembre', 'Diciembre'],
        datasets: [{
          label: 'WEDDINGS',
          data: [this.enero, this.febrero, this.marzo, this.abril, this.mayo, this.junio, this.julio, this.agosto,
            this.septiembre, this.octubre, this.noviembre, this.diciembre],
          backgroundColor: [
            'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)',
            'rgba(255, 159, 64, 0.2)',
            'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)',
            'rgba(255, 159, 64, 0.2)'
          ],
          borderColor: [
            'rgba(255, 99, 132, 1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)',
            'rgba(255, 99, 132, 1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)'
          ],
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero: true
            }
          }]
        }
      }
    });

    this.pieChart = new Chart('pieChart', {
      type: 'pie',
      data: {
        labels: ['2019', '2020', '2021', '2022', '2023'],
        datasets: [{
          label: 'WEDDINGS',
          data: [this.dosMilDiecinueve, this.dosMilVeinte, this.dosMilVeintiuno, this.dosMilVeintidos, this.dosMilVeintitres],
          backgroundColor: [
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)',
            'rgba(255, 159, 64, 0.2)'
          ],
          borderColor: [
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)'
          ],
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero: true
            }
          }]
        }
      }
    });
  }

}
