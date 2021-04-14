codeunit 31014 "Fin. Charge Memo Handler CZL"
{
    var
        BankOperationsFunctionsCZL: Codeunit "Bank Operations Functions CZL";

    [EventSubscriber(ObjectType::Table, Database::"Finance Charge Memo Header", 'OnAfterValidateEvent', 'Customer No.', false, false)]
    local procedure UpdateRegNoOnAfterCustomerNoValidate(var Rec: Record "Finance Charge Memo Header")
    var
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
    begin
        CompanyInformation.Get();
        Rec.Validate("Bank Account Code CZL", CompanyInformation."Default Bank Account Code CZL");

        if Rec."Customer No." <> '' then begin
            Customer.Get(Rec."Customer No.");
            Rec."Registration No. CZL" := Customer."Registration No. CZL";
            Rec."Tax Registration No. CZL" := Customer."Tax Registration No. CZL";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FinChrgMemo-Issue", 'OnAfterInitGenJnlLine', '', false, false)]
    local procedure UpdateBankInfoOnAfterInitGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; FinChargeMemoHeader: Record "Finance Charge Memo Header")
    begin
        GenJnlLine."VAT Date CZL" := FinChargeMemoHeader."Posting Date";
        if GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Customer then
            exit;

        GenJnlLine."Specific Symbol CZL" := FinChargeMemoHeader."Specific Symbol CZL";
        if FinChargeMemoHeader."Variable Symbol CZL" <> '' then
            GenJnlLine."Variable Symbol CZL" := FinChargeMemoHeader."Variable Symbol CZL"
        else
            GenJnlLine."Variable Symbol CZL" := BankOperationsFunctionsCZL.CreateVariableSymbol(FinChargeMemoHeader."No.");
        GenJnlLine."Constant Symbol CZL" := FinChargeMemoHeader."Constant Symbol CZL";
        GenJnlLine."Bank Account Code CZL" := FinChargeMemoHeader."Bank Account Code CZL";
        GenJnlLine."Bank Account No. CZL" := FinChargeMemoHeader."Bank Account No. CZL";
        GenJnlLine."Transit No. CZL" := FinChargeMemoHeader."Transit No. CZL";
        GenJnlLine."IBAN CZL" := FinChargeMemoHeader."IBAN CZL";
        GenJnlLine."SWIFT Code CZL" := FinChargeMemoHeader."SWIFT Code CZL";
    end;
}
