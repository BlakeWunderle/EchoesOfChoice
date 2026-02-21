using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class WhipCrack : Ability
    {
        public WhipCrack()
        {
            Name = "Whip Crack";
            FlavorText = "The crack of the whip energizes allies. Increases attacks.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 7;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
