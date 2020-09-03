global class ClearRooms implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<Room__c> rooms = [SELECT Name, Room_Number__c, isAvailable__c
            FROM Room__c 
            WHERE isAvailable__c = False];
        // Create a task for each opportunity in the list
        //TaskUtils.remindOwners(rooms);
    }
    
    
    
}