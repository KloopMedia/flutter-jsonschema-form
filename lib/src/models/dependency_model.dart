import '../helpers/form_data_helper.dart';
import 'models.dart';

class Dependency {
  final String parentId;
  final PathModel parentPath;
  final List<dynamic> conditions;
  final Dependency? parentDependency;

  Dependency({
    required this.parentId,
    required this.parentPath,
    required this.conditions,
    required this.parentDependency,
  });

  bool shouldRenderDependency(Map<String, dynamic> formData) {
    final data = getFormDataByPath(formData, parentPath);

    if (!conditions.contains(data)) {
      return false;
    }

    if (parentDependency != null) {
      return parentDependency!.shouldRenderDependency(formData);
    } else {
      return true;
    }
  }
}
