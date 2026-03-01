using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class SavageMaul : Ability
    {
        public SavageMaul()
        {
            Name = "Savage Maul";
            FlavorText = "Transform partially and maul the enemy with bestial claws.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
