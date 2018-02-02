C (c) CROWN COPYRIGHT 1995, METEOROLOGICAL OFFICE, All Rights Reserved.
C
C Use, duplication or disclosure of this code is subject to the
C restrictions as set forth in the contract.
C
C                Meteorological Office
C                London Road
C                BRACKNELL
C                Berkshire UK
C                RG12 2SZ
C
C If no contract has been raised with this copy of the code, the use,
C duplication or disclosure of it is strictly prohibited.  Permission
C to do so must first be obtained in writing from the Head of Numerical
C Modelling at the above address.
C ******************************COPYRIGHT******************************
C
!   SUBROUTINE GLUE_CLD-------------------------------------------------
!
!   Level 3 control routine
!
!   Purpose: Calls LS_CLD to calculate large-scale cloud cover and
!            cloud water contents, from liquid water temperature and
!            total water content, which are updated to temperature and
!            specific humidity respectively.
!            It is an extra level of control routine to avoid using
!            *IF DEF around calls to different LS_CLD versions, as per
!            S. Foreman's 22/8/94 proposal for plug compatibility.
!
!   A09_1A : Standard large-scale cloud scheme.
!   A09_2A : Experimental Liquid and Ice Cloud Fractional Cover
!
!   Called by : SETCONA1
!               SETLSCL1
!               CLDCTL1
!               BL_CTL1
!               ATMDYN1
!               VISBTY1A      (not at vn4.5 onwards)
!               AC_CTL1
!               THL2TH1
!               VANMOPS_MIXED_PHASE
!
!   Code description: Language FORTRAN 77 + extensions.
!
!   Programming standard: Unified Model Documentation Paper No 3,
!                         Version 6.
!
!   Author: Andrew Bushell     Reviewer: C. Wilson
!
!   Modification History from UM Version 4.0:
!    Version      Date
!
!      4.4        01/07/97  Changes to use of arguments if 2A scheme is
!                           chosen.       A.C.Bushell
!      4.5        13/05/98  Altered argument list (dummy variable).
!                                        S. Cusack
!
!   System components covered :
!
!   System task :
!
!   Documentation: UMDP No.
!
!  END -----------------------------------------------------------------
!
      SUBROUTINE GLUE_CLD(
     & AK,BK,PSTAR,RHCRIT,LEVELS,DUMMY,
     & POINTS,PFIELD,
     & T,CF,Q,QCF,QCL,PDF_QC_OR_CF_LIQ,PDF_BS_OR_CF_ICE,ERROR
     & )
      IMPLICIT NONE
!-----------------------------------------------------------------------
! All variables are used in this LS_CLD version
!-----------------------------------------------------------------------
! IN variables
!-----------------------------------------------------------------------
      INTEGER LEVELS           ! No. of levels being processed.
!
      INTEGER POINTS           ! No. of gridpoints being processed.
!
      INTEGER PFIELD           ! No. of points in global field (at one
!                                vertical level).
!
      REAL PSTAR(PFIELD)       ! Surface pressure (Pa).
!
      REAL RHCRIT(LEVELS)      ! Critical relative humidity.  See the
!                                the paragraph incorporating eqs P292.11
!                                to P292.14; the values need to be tuned
!                                for the given set of levels.
      REAL AK(LEVELS)          ! Hybrid "A" co-ordinate.
      REAL BK(LEVELS)          ! Hybrid "B" co-ordinate.
!-----------------------------------------------------------------------
! INOUT variables
!-----------------------------------------------------------------------
      REAL Q(PFIELD,LEVELS)    ! On input:  Total water content (QW)
!                                           (kg per kg air).
!                                On output: Specific humidity at process
!                                           levels (kg water per kg air)
      REAL T(PFIELD,LEVELS)    ! On input:  Liquid/frozen water
!                                           temperature (TL) (K).
!                                On output: Temperature at processed
!                                           levels (K).
!-----------------------------------------------------------------------
! OUT variables
!-----------------------------------------------------------------------
      REAL CF(PFIELD,LEVELS)     ! Cloud fraction at processed levels
!                                  (decimal fraction).
      REAL QCF(PFIELD,LEVELS)    ! Cloud ice content at processed levels
!                                  (kg per kg air).
      REAL QCL(PFIELD,LEVELS)    ! Cloud liquid water content at
!                                  processed levels (kg per kg air).
      REAL PDF_QC_OR_CF_LIQ(PFIELD,LEVELS)
! 1A: Grid-box mean cloud condensate at processed levels (kg/ kg air).
! 2A: Liquid cloud fraction on model levels.
      REAL PDF_BS_OR_CF_ICE(PFIELD,LEVELS)
! 1A: Maximum moisture fluctuation /6*sigma on levels (kg per kg air).
! 2A: Frozen cloud fraction on model levels.
      REAL DUMMY(PFIELD,LEVELS)  ! Dummy variable for this version
      INTEGER ERROR              ! 0 if OK; 1 if bad arguments.
!
!    External subroutine called ----------------------------------------
      EXTERNAL  LS_CLD
!----------------------------------------------------------------------
!
      CALL LS_CLD(
     &    AK, BK, PSTAR,
     &    RHCRIT, LEVELS,
     &    POINTS, PFIELD, T,
     &    CF, Q, QCF, QCL,
     &    PDF_QC_OR_CF_LIQ, PDF_BS_OR_CF_ICE, ERROR
     & )
!
      RETURN
      END
