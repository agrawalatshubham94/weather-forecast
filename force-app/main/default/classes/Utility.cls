public class Utility {
    
    /*****************************************************************************************************************************
     * Method Name : getMetadata
     * Parameters : metaName - API name of the metadata to be queried.
     * Return type : Map<String, sObject> - Map of queried result with MasterLabel as key.
     */
    public static Map<String, sObject> getMetadata (String metaName) {
        Map<String, sObject> metaMap = new Map<String, sObject>();        
        String fieldString = '';        
        
        if (String.isBlank(metaName)) return metaMap;
        
        List<String> fieldSet = new List<String>(Schema.getGlobalDescribe().get(metaName).getDescribe().fields.getMap().keySet());
        for (Integer i=0; i<fieldSet.size(); i++) {
            if (i == fieldSet.size()-1) {
                fieldString = fieldString + fieldSet[i];
            } else {
                fieldString = fieldString + fieldSet[i] + ',';
            }            
        }
        
        String queryString = 'SELECT ' + fieldString + ' FROM ' + metaName;
        
        List<sObject> sobjList = Database.query(queryString);
        
        if (!sobjList.isEmpty()) {
            for (sObject obj : sobjList) {
                metaMap.put((String)obj.get('MasterLabel'), obj);
            }
        }
        
        return metaMap;
    }
}