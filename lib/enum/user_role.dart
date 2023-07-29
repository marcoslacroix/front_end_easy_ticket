enum UserRole {
  CREATE_COMPANY,
  UPDATE_COMPANY,
  DELETE_COMPANY,
  CREATE_TICKET,
  UPDATE_LOTS,
  CHECKING_TICKET,
  CREATE_EVENT,
  UNKNOW,
}

UserRole parseUserRole(String role) {
  switch (role) {
    case 'CREATE_COMPANY':
      return UserRole.CREATE_COMPANY;
    case 'UPDATE_COMPANY':
      return UserRole.UPDATE_COMPANY;
    case 'DELETE_COMPANY':
      return UserRole.DELETE_COMPANY;
    case 'CREATE_TICKET':
      return UserRole.CREATE_TICKET;
    case 'UPDATE_LOTS':
      return UserRole.UPDATE_LOTS;
    case 'CHECKING_TICKET':
      return UserRole.CHECKING_TICKET;
    case 'CREATE_EVENT':
      return UserRole.CREATE_EVENT;
    default:
      return UserRole.UNKNOW;
  }
}
