
import 'package:intl/intl.dart';

class Helpers {
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }
  
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
  
  static String getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'confirmed':
        return 'Confirmado';
      case 'delivered':
        return 'Entregado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }
  
  static String getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'frutas':
        return '🍎';
      case 'verduras':
        return '🥬';
      case 'cereales':
        return '🌾';
      case 'legumbres':
        return '🫘';
      case 'hierbas':
        return '🌿';
      default:
        return '🌱';
    }
  }
}
