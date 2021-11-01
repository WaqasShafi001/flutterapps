class NetworkConstantsUtil {
  static String baseUrl = 'https://starwebapk.com/api/web/v1/';

  static String login = 'users/login';
  static String socialLogin = 'users/login-social';
  static String forgotPassword = 'users/forgot-password';
  static String register = 'users/register';

  static String forgotPwd = 'users/forgot-password';
  static String updateProfile = 'users/profile-update';
  static String getProfile =
      'users/profile?expand=userLocation,activeSubscripton.package,following.followingUserDetail.userLocation,follower.followerUserDetail.userLocation';

  static String getVideos = 'categories/category-post?expand=post';
  static String getPhotos = 'gallaries';
  static String uploadProfileImage = 'users/update-profile-image';

  static String getSettings = 'settings';

  static String uploadVideoWithImage = '';
}
