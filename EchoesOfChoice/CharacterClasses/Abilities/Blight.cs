using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Blight : Ability
    {
        public Blight()
        {
            Name = "Blight";
            FlavorText = "A cloud of pestilence engulfs the enemy, dealing necrotic damage.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
