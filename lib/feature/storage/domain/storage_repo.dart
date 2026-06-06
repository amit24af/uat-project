abstract class StorageRepo{
  Future<String?> uploadProfileImageMobile(String path, String fileName);
  Future<String?> uploadPostImageMobile(String path, String fileName);
}