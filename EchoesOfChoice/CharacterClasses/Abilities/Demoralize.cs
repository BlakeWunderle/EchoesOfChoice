using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Demoralize : Ability
    {
        public Demoralize()
        {
            Name = "Demoralize";
            FlavorText = "A mocking performance that saps the enemy's fighting spirit. Reduces attacks.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
            TargetAll = true;
        }
    }
}
