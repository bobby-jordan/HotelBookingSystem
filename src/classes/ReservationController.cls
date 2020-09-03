public class ReservationController {

    public List<Reservation__c> listReservation { get; set; }
    public Reservation__c reservation { get; set; }
    public Room__c room { get; set; }
    public List<Room__c> listRooms { get; set; }

    public Id resId = ApexPages.currentPage().getParameters().get('id');
    public String keyWord { get; set; }

    List<string> conditions = new List<string>();
    public Integer totalRecs = 0;
    public Integer OffsetSize = 0;
    public Integer LimitSize = 5;

    public String strQuery = 'SELECT Id,Name,Date_Occupied__c,Duration__c,Release_Date__c,Room__c,Room__r.Name FROM Reservation__c ';

    public ReservationController() {

        if (resId == null) {
            this.reservation = new Reservation__c();
        } else {
            this.reservation = [
                    SELECT Id,Name,Date_Occupied__c,Duration__c,Release_Date__c,Room__c,Room__r.Name
                    FROM Reservation__c
                    WHERE Id = :ApexPages.currentPage().getParameters().get('id')
            ];
        }

        this.listReservation = getReservations();
        this.listRooms = getRooms();
        totalRecs = [SELECT count() FROM Reservation__c];
    }

    public List<Reservation__c> getReservations() {

        List<Reservation__c> listReservation = Database.Query(strQuery);
        //System.debug('Values: ' + listReservation);
        return listReservation;
    }
    public PageReference sort() {
        return null;
    }

    public void searchReservation() {
        totalRecs = 0;
        OffsetSize = 0;
        if (listReservation != null && listReservation.size() > 0) {
            listReservation = null;
        }
        searchRes();
        conditions.clear();
    }


    public void searchRes() {

        //System.debug('Total Records is:    ' + totalRecs);
        //System.debug('OffsetSize is:    ' + OffsetSize);
        reservation.Name = keyWord;

        if (listReservation != null && !listReservation.isEmpty()) {
            listReservation.clear();
        }

        if (reservation.Name != null && reservation.Name != '') {
            conditions.add('Name Like \'%' + reservation.Name + '%\' ');
        }

        if (conditions.size() > 0) {
            strQuery += '  WHERE ' + conditions[0];
            for (Integer i = 1; i < conditions.size(); i++)
                strQuery += '  AND ' + conditions[i];
        }
        if (totalRecs != null && totalRecs == 0) {
            List<Reservation__c> resTemp = Database.query(strQuery);
            totalRecs = (resTemp != null && resTemp.size() > 0) ? resTemp.size() : 0;
        }

        //System.debug('strQuery ==>' + strQuery);
        // add sort and limits at the end
        strQuery += ' ORDER BY Name ASC LIMIT :LimitSize OFFSET :OffsetSize';

        listReservation = Database.query(strQuery);

    }


    public void FirstPage() {
        OffsetSize = 0;
    }

    public void previous() {
        OffsetSize = OffsetSize - LimitSize;
    }

    public void next() {
        OffsetSize = OffsetSize + LimitSize;
    }

    public void LastPage() {
        OffsetSize = totalRecs - math.mod(totalRecs, LimitSize);
    }

    public Boolean getprev() {
        if (OffsetSize == 0)
            return true; else
                return false;
    }

    public Boolean getnxt() {
        if ((OffsetSize + LimitSize) > totalRecs)
            return true; else
                return false;
    }

    public Reservation__c getItem() {
        return [SELECT Id,Name,Date_Occupied__c,Duration__c,Release_Date__c,Room__c,Room__r.Name FROM Reservation__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    }

    public List<Room__c> getRooms() {
        return [SELECT Id,Name,isAvailable__c,Room_Number__c FROM Room__c];
    }

    public PageReference saveReservation() {

        try {
            upsert reservation;
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Just a message!');
            ApexPages.addMessage(myMsg);
        }
        PageReference returnPage = ApexPages.currentPage();
        returnPage.setRedirect(true).getParameters().clear();
        return returnPage;
    }

    public PageReference remove() {

        System.debug('Test ' + ApexPages.currentPage().getParameters().get('id'));
        try {
            delete [SELECT Id,Name,Date_Occupied__c,Duration__c,Release_Date__c,Room__c FROM Reservation__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Just a message!');
            ApexPages.addMessage(myMsg);
        }
        PageReference returnPage = ApexPages.currentPage();
        returnPage.setRedirect(true).getParameters().clear();
        return returnPage;
    }

    public PageReference editReservation() {

        reservation = (Reservation__c) getItem();
        System.debug(reservation);
        PageReference redirectSuccess = ApexPages.currentPage();
        redirectSuccess.getParameters().put('id', reservation.Id);
        return redirectSuccess;
    }

    public List<PieWedgeData> getPieData() {
        List<PieWedgeData> data = new List<PieWedgeData>();
        data.add(new PieWedgeData('Test', 30));
        data.add(new PieWedgeData('NewReservation', 50));
        data.add(new PieWedgeData('Reservation', 20));
        return data;
    }

    public class PieWedgeData {
        public String name {
            get;
            set;
        }
        public Integer data {
            get;
            set;
        }
        public PieWedgeData(String name, Integer data) {
            this.name = name;
            this.data = data;
        }
    }
}