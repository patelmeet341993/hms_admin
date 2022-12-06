import 'package:admin/views/visit/components/add_visit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';

class MyVisitController {
  Future<void> createDummyVisitDataInFirestore() async {
    VisitModel visitModel = VisitModel(
      id: MyUtils.getUniqueIdFromUuid(),
      patientId: "tBDre2xeNpifcG6wZYiv",
      description: "High Fever",
      createdTime: Timestamp.now(),
      updatedTime: Timestamp.now(),
      doctors: {
        AdminUserType.admin : "gjf3Mx4YV1TzAyP7xm0N",
      },
      weight: 70,
      currentDoctorId: "gjf3Mx4YV1TzAyP7xm0N",
      currentDoctorName: "Bhavisha Parmar",
      active: true,
      diagnosis: [
        DiagnosisModel(
          doctorId: "gjf3Mx4YV1TzAyP7xm0N",
          diagnosisDescription: "Patient must have food poison",
          prescription: [
            PrescriptionModel(
              medicineName: "Calpol 650",
              medicineType: MedicineType.tablet,
              doses: [
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.morning,
                  dose: "1",
                  afterMeal: true,
                ),
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.night,
                  dose: "1",
                  afterMeal: true,
                ),
              ],
              repeatDurationDays: 1,
              totalDays: 5,
              totalDose: "10",
            ),
            PrescriptionModel(
              medicineName: "Cloben G",
              medicineType: MedicineType.other,
              doses: [
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.morning,
                  dose: "1",
                ),
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.night,
                  dose: "1",
                ),
              ],
              repeatDurationDays: 1,
              totalDose: "1",
              totalDays: 10,
            ),
            PrescriptionModel(
              medicineName: "Cough Syrup",
              medicineType: MedicineType.syrup,
              doses: [
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.morning,
                  dose: "20 ml",
                  afterMeal: false,
                ),
                PrescriptionMedicineDoseModel(
                  doseTime: PrescriptionMedicineDoseTime.night,
                  dose: "20 ml",
                  afterMeal: true,
                ),
              ],
              repeatDurationDays: 1,
              totalDose: "200 ml",
              totalDays: 10,
            ),
          ],
        ),
      ],
      visitBillings: {
        "gjf3Mx4YV1TzAyP7xm0N" : VisitBillingModel(
          doctorId: "gjf3Mx4YV1TzAyP7xm0N",
          createdTime: Timestamp.now(),
          fee: 600,
          discount: 100,
          totalFees: 500,
          paymentMode: PaymentModes.cash,
          paymentId: "Cash",
        ),
      },
      pharmaBilling: PharmaBillingModel(
        patientId: "tBDre2xeNpifcG6wZYiv",
        createdTime: Timestamp.now(),
        baseAmount: 1800,
        discountAmount: 450,
        discountPercentage: 10,
        totalAmount: 1350,
        paymentMode: PaymentModes.upi,
        paymentId: "Gpay_1234xyz",
        paymentStatus: PaymentStatus.paid,
        items: [
          PharmaBillingItemModel(
            medicineName: "Calpol 650",
            dose: "10",
            dosePerUnit: "5",
            unitCount: 2,
            price: 10,
            finalAmount: 20,
          ),
          PharmaBillingItemModel(
            medicineName: "Cloben G",
            dose: "1",
            dosePerUnit: "1",
            unitCount: 1,
            price: 600,
            finalAmount: 600,
          ),
          PharmaBillingItemModel(
            medicineName: "Cough Syrup",
            dose: "1",
            dosePerUnit: "1",
            unitCount: 1,
            price: 1200,
            finalAmount: 1200,
          ),
        ],
      ),
      previousVisitId: "",
    );

    await FirebaseNodes.visitDocumentReference(visitId: visitModel.id).set(visitModel.toMap()).then((value) {
      MyPrint.printOnConsole("Visit Created Successfully with id:${visitModel.id}");
    })
    .catchError((e, s) {
      MyPrint.printOnConsole("Error in VisitController().createDummyVisitDataInFirestore():$e");
      MyPrint.printOnConsole(s);
    });
  }

  Future<bool> showAddVisitDialog({required BuildContext context, required String patientId, PatientModel? patientModel}) async {
    if(patientId.isEmpty) return false;

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddVisitDialog(
          patientId: patientId,
          patientModel: patientModel,
        );
      },
    );

    return ParsingHelper.parseBoolMethod(value);
  }
}