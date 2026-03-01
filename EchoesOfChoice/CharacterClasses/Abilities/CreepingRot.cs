using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class CreepingRot : Ability
    {
        public CreepingRot()
        {
            Name = "Creeping Rot";
            FlavorText = "Curse the target with a spreading decay that saps their strength.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 2;
            impactedTurns = 3;
            UseOnEnemy = true;
            ManaCost = 4;
            DamagePerTurn = 3;
        }
    }
}
