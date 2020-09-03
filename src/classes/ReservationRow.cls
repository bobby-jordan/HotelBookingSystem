public with sharing class ReservationRow{

    public Contact tContact{get;set;}
    public Boolean IsSelected{get;set;}

    public ReservationRow(Contact c, Boolean s){
        this.tContact=c;
        this.IsSelected=s;
    }

}


