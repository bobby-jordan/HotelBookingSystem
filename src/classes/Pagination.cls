public class Pagination {
    private integer totalRecs = 0;
    private integer OffsetSize = 0;
    private integer LimitSize = 10;
    public Pagination() {
        totalRecs = [select count() from account];
    }
    public List<account> getacclist() {
        List<account> acc = Database.Query('SELECT Name, website, AnnualRevenue, description, Type FROM account LIMIT :LimitSize OFFSET :OffsetSize');
        System.debug('Values are ' + acc);
        return acc;
    }
    public void one() {
        OffsetSize = 0;
    }
    public void previous() {
        OffsetSize = OffsetSize - LimitSize;
    }public void next() {
        OffsetSize = OffsetSize + LimitSize;
    }public void LastPage() {
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
}