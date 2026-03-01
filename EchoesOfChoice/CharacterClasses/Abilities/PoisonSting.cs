using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class PoisonSting : Ability
    {
        public PoisonSting()
        {
            Name = "Poison Sting";
            FlavorText = "Inject a virulent toxin that eats away at the target.";
            ModifiedStat = StatEnum.Health;
            Modifier = 0;
            impactedTurns = 3;
            UseOnEnemy = true;
            ManaCost = 3;
            DamagePerTurn = 3;
        }
    }
}
